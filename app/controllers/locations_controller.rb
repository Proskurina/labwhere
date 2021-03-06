class LocationsController < ApplicationController

  before_action :locations, only: [:index]
  before_action :set_location, except: [:index, :activate, :deactivate]
  
  def index
  end

  def new
  end

  def show
    @location = current_resource
  end

  def create
    if @location.submit(params)
      redirect_to locations_path, notice: "Location successfully created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @location.submit(params)
      redirect_to locations_path, notice: "Location successfully updated"
    else
      render :edit
    end
  end

  def deactivate
    @location = current_resource
    @location.deactivate
    redirect_to locations_path, notice: "Location successfully deactivated"
  end

  def activate
    @location = current_resource
    @location.activate
    redirect_to locations_path, notice: "Location successfully activated"
  end

protected

  def locations
    @locations = Location.by_building
  end

  helper_method :locations

private

  def set_location
    @location = LocationForm.new(current_resource)
  end

  def current_resource
    @current_resource ||= Location.includes(:labwares).find(params[:id]) if params[:id]
  end

end
