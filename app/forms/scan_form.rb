##
# This will create a persisted scan.
# It can be used from a view or elsewhere.
# 
class ScanForm

  include ActiveModel::Model
  include AuditUser

  attr_reader :scan
  attr_accessor :location_barcode, :labware_barcodes
  delegate :location, :message, to: :scan

  validate :check_for_errors

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Scan")
  end

  def initialize
  end

  def submit(params)
    @params = params
    @location_barcode = params[:scan][:location_barcode]
    @labware_barcodes = params[:scan][:labware_barcodes]
    @user = find_user(params[:scan][:user])
    scan.location = Location.find_by(barcode: location_barcode)
    scan.user = user
    if valid?
      Labware.build_for(scan, labware_barcodes)
      scan.save
    else
      false
    end
  end

  def scan
    @scan ||= Scan.new
  end

private

  def check_for_errors
    LocationValidator.new.validate(self)
  end
  
end