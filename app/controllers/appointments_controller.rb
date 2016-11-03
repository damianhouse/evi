class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :set_appointments, only: [:index, :all_appointments, :show, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /appointments
  # GET /appointments.json
  def index
  end

  def all_appointments
  end
  # GET /appointments/1
  # GET /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  def sort_appointments
    if params[:user][:id] == ""
      @appointments = Appointment.all
    else
      @appointments = Appointment.where("user_id = ?", params[:user][:id])
    end
  end

  def sort_appointments_list
    if params[:user][:id] == ""
      @appointments = Appointment.all
    else
      @appointments = Appointment.where("user_id = ?", params[:user][:id])
    end
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      @appointments = Appointment.all
      render notice: 'Appointment was successfully created.'
    else
      render :new, notice: 'Appointment was unable to be created. Check your fields.'
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    @appointment.update(appointment_params)
    update_invoice(@appointment) if @appointment.invoice_id.present?
    @appointment.save!
    @appointemnts = Appointment.all
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    update_invoice(@appointment) if @appointment.invoice_id.present?

    @appointments = Appointment.all
    redirect_to root_path
  end

  def close_all
    @appointments = Appointment.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def update_invoice(appointment)
      user = User.find(@appointment.user_id)
      @invoice = Invoice.find(@appointment.invoice_id)
      appointments = Appointment.where('invoice_id = ?', @appointment.invoice_id)
      @invoice.miles_total = appointments.reduce(0){|sum, x| sum + x.miles_driven}
      @invoice.hours_total = appointments.reduce(0){|sum, x| sum + (x.end_time - x.start_time) / (60*60)}
      @invoice.total_paid = ((@invoice.hours_total * user.hourly_rate) + (@invoice.miles_total * 1))
      @invoice.save!
    end
    def set_appointments
      @appointments = Appointment.all
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:patient_id, :user_id, :invoice_id, :note, :clinic, :start_time, :end_time, :miles_driven, :complete, :paid_for, :cancelled, :no_show)
    end
end
