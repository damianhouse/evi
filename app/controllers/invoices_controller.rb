class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :paid]
  respond_to :html, :js

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    user = User.find(@invoice.user_id)
    hourly_rate = user.hourly_rate
    start_date = @invoice.start_date
    end_date = @invoice.end_date
    appointments = Appointment.all.where('user_id = ? AND start_time >= ? AND end_time <= ?', user.id, start_date, end_date)
    @invoice.miles_total = 0.0
    @invoice.hours_total = 0.0
    unless appointments.empty?
      appointments.each do |appointment|
        @invoice.miles_total += appointment.miles_driven
        @invoice.hours_total += (appointment.end_time - appointment.start_time) / (60*60)
        @invoice.total_paid = ((@invoice.hours_total * hourly_rate) + (@invoice.miles_total * 1))
      end
      @invoice.save!

      render notice: "Invoice was succesfully created."
    else
      render :new, notice: 'Invoice was unable to be created. No appointments in this time frame.'
    end

  end

  def paid
    appointments = Appointment.all.where('invoice_id = ?', @invoice.id)
    appointments.each do |appointment|
      appointment.paid_for = true
      appointment.save
    end
    @invoice.paid_on = Date.today
    @invoice.save
    
    render notice: "Invoice and coorsponding appointments were successfully marked as paid."
  end
  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    @invoice.update(invoice_params)

    @appointments = Appointment.all
    redirect_to @invoice
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
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
