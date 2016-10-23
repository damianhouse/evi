class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :paid, :unpaid, :paid_list, :unpaid_list]
  respond_to :html, :js

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
    @interpreters = @invoices.map { |x| User.find(x.user_id)}
    @interpreters = @interpreters.uniq
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @appointments = Appointment.all.where('invoice_id = ?', @invoice.id)
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  def auto_create
    @appointments = Appointment.where('complete = ? AND invoice_id IS NULL', true).where.not(user_id: nil)
    @users = @appointments.to_a.map { |x| User.find(x.user_id)}
    @users = @users.uniq
    @invoices = []
    @users.each do |user|
      appointments = Appointment.all.where('complete = ? AND invoice_id IS NULL AND user_id = ?', true, nil, user.id)
      invoice = Invoice.new(user_id: user.id, start_date: appointments.order('start_time asc').limit(1)[0].start_time.strftime("%y-%m-%d"), end_date: appointments.order('start_time desc').limit(1)[0].start_time.strftime("%y-%m-%d"))
      invoice.miles_total = appointments.reduce(0){|sum, x| sum + x.miles_driven}
      invoice.hours_total = appointments.reduce(0){|sum, x| sum + (x.end_time - x.start_time) / (60*60)}
      invoice.total_paid = ((invoice.hours_total * user.hourly_rate) + (invoice.miles_total * 1))
      invoice.save!
      @invoices << invoice
      appointments.each do |appointment|
        appointment.invoice_id = invoice.id
        appointment.save!
      end
    end
    @invoices
  end
  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    user = User.find(@invoice.user_id)
    appointments = Appointment.all.where('user_id = ? AND start_time >= ? AND end_time <= ? AND complete = ?', user.id, @invoice.start_date, @invoice.end_date, true)
    @invoice.miles_total = 0.0
    @invoice.hours_total = 0.0
    unless appointments.empty?
      appointments.each do |appointment|
        @invoice.miles_total += appointment.miles_driven
        @invoice.hours_total += (appointment.end_time - appointment.start_time) / (60*60)
        @invoice.total_paid = ((@invoice.hours_total * user.hourly_rate) + (@invoice.miles_total * 1))
      end
      @invoice.save!
      appointments.each do |appointment|
        appointment.invoice_id = @invoice.id
        appointment.save
      end
      render notice: "Invoice was succesfully created."
    else
      render :new, notice: 'Invoice was unable to be created. No appointments in this time frame.'
    end

  end
  # GET
  def paid
    @appointments = Appointment.all.where('invoice_id = ?', @invoice.id)
    @appointments.each do |appointment|
      appointment.paid_for = true
      appointment.save
    end
    @invoice.paid_on = Date.today
    @invoice.save
    @invoices = Invoice.all
    @interpreters = @invoices.map { |x| User.find(x.user_id)}
    @interpreters = @interpreters.uniq

    render notice: "Invoice and coorsponding appointments were successfully marked as paid."
  end
  # GET
  def unpaid
    @appointments = Appointment.all.where('invoice_id = ?', @invoice.id)
    @appointments.each do |appointment|
      appointment.paid_for = false
      appointment.save
    end
    @invoice.paid_on = nil
    @invoice.save
    @invoices = Invoice.all
    @interpreters = @invoices.map { |x| User.find(x.user_id)}
    @interpreters = @interpreters.uniq

    render notice: "Invoice and coorsponding appointments were successfully marked as unpaid."
  end

  # GET
  def paid_list
    @appointments = Appointment.all.where('invoice_id = ?', @invoice.id)
    @appointments.each do |appointment|
      appointment.paid_for = true
      appointment.save
    end
    @invoice.paid_on = Date.today
    @invoice.save
    @invoices = Invoice.all
    @interpreters = @invoices.map { |x| User.find(x.user_id)}
    @interpreters = @interpreters.uniq

    render notice: "Invoice and coorsponding appointments were successfully marked as paid."
  end
  # GET
  def unpaid_list
    @appointments = Appointment.all.where('invoice_id = ?', @invoice.id)
    @appointments.each do |appointment|
      appointment.paid_for = false
      appointment.save
    end
    @invoice.paid_on = nil
    @invoice.save
    @invoices = Invoice.all
    @interpreters = @invoices.map { |x| User.find(x.user_id)}
    @interpreters = @interpreters.uniq

    render notice: "Invoice and coorsponding appointments were successfully marked as unpaid."
  end
  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    @invoice.update(invoice_params)

    @appointments = Appointment.all
    redirect_to @invoice
  end

  def sort_invoices
    @invoices = Invoice.all
    @interpreters = @invoices.map { |x| User.find(x.user_id)}
    @interpreters = @interpreters.uniq
    if params[:user][:id] == ""
      @sorted_invoices = Invoice.all
    else
      @user = User.find(params[:user][:id])
      @sorted_invoices = Invoice.all.where('user_id = ?', @user.id)
    end
    @sorted_invoices
  end
  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    appointments = Appointment.where('invoice_id = ?', @invoice.id)
    appointments.each do |appt|
      appt.invoice_id = nil
      appt.save!
    end
    @invoice.destroy
    redirect_to appointments_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def to_hours
      self / (60.0*60.0)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:user_id, :miles_total, :hours_total, :total_paid, :paid_on, :start_date, :end_date)
    end
end
