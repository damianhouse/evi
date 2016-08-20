class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /patients
  # GET /patients.json
  def index
    @patients = Patient.all
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)

    unless @patient.save
      render :new, notice: 'Appointment was unable to be created. Check your fields.'
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    @patient.update(patient_params)

    @appointemnts = Appointment.all
    redirect_to appointments_path
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    render :close_all
  end

  def close_all
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:first_name, :last_name, :email, :phone_number)
    end
end
