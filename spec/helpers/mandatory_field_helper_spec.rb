require "spec_helper"

RSpec.describe MandatoryFieldHelper, type: :helper do
  context "#validate_mandatory_text_fields" do
    it "returns an array of mandatory text field not populated" do
      session["full_name"] = ""
      session["job_title"] = "text"
      invalid_fields = validate_mandatory_text_fields(%w[full_name job_title], "contact_information")
      expect(invalid_fields).to eq [{ text: "Enter full name" }]
    end

    it "returns a custom error when email address not populated" do
      session["email_address"] = ""
      invalid_fields = validate_mandatory_text_fields(%w[email_address], "contact_information")
      expect(invalid_fields).to eq [{ text: "Enter email address in the correct format, like name@example.com" }]
    end

    it "returns a custom error when postcode not populated" do
      session["address_postcode"] = ""
      invalid_fields = validate_mandatory_text_fields(%w[address_postcode], "organisation_details")
      expect(invalid_fields).to eq [{ text: "Enter a real postcode" }]
    end
  end

  context "#validate_date_fields" do
    it "returns an error if year is blank" do
      invalid_fields = validate_date_fields("", "6", "25", "Date")
      expect(invalid_fields).to eq [{ text: "Date must include a year" }]
    end

    it "returns an error if month is blank" do
      invalid_fields = validate_date_fields("1990", "", "25", "Date")
      expect(invalid_fields).to eq [{ text: "Date must include a month" }]
    end

    it "returns an error if day is blank" do
      invalid_fields = validate_date_fields("1990", "6", "", "Date")
      expect(invalid_fields).to eq [{ text: "Date must include a day" }]
    end

    it "returns multiple errors if multiple date fields are blank" do
      invalid_fields = validate_date_fields("", "", "", "Date")
      expect(invalid_fields).to eq [
        { text: "Date must include a year" },
        { text: "Date must include a month" },
        { text: "Date must include a day" },
      ]
    end

    it "returns an error if date is not valid" do
      invalid_fields = validate_date_fields("2019", "02", "30", "Date")
      expect(invalid_fields).to eq [{ text: "Enter a real date" }]
    end
  end

  context "#validate_radio_field" do
    it "return an error if no radio button selected" do
      invalid_fields = validate_radio_field("organisation_type", radio: "", other: "")
      expect(invalid_fields).to eq [{ text: "Select organisation type" }]
    end

    it "returns an error when Other selected but no custom text entered" do
      invalid_fields = validate_radio_field("organisation_type", radio: "Other", other: "")
      expect(invalid_fields).to eq [{ text: "Enter organisation type" }]
    end

    it "returns a custom error when companies house radio buttons not selected" do
      invalid_fields = validate_radio_field("companies_house_or_charity_commission_number", radio: "", other: "")
      expect(invalid_fields).to eq [{ text: "Select yes if you have a Companies House or Charity Commission number" }]
    end

    it "returns a custom error when companies house yes is selected but no value entered" do
      invalid_fields = validate_radio_field("companies_house_or_charity_commission_number", radio: "Yes", other: "")
      expect(invalid_fields).to eq [{ text: "Enter Companies House or Charity Commission number" }]
    end

    it "returns a custom error when grant number radio buttons not selected" do
      invalid_fields = validate_radio_field("grant_agreement_number", radio: "", other: "")
      expect(invalid_fields).to eq [{ text: "Select yes if you have a grant agreement number" }]
    end

    it "returns a custom error when grant number yes is selected but no value entered" do
      invalid_fields = validate_radio_field("grant_agreement_number", radio: "Yes", other: "")
      expect(invalid_fields).to eq [{ text: "Enter grant agreement number" }]
    end

    it "returns a custom error when programme radio buttons not selected" do
      invalid_fields = validate_radio_field("programme_funding", radio: "", other: "")
      expect(invalid_fields).to eq [{ text: "Select what programme you receive funding from" }]
    end

    it "returns a custom error when outside UK participants radio buttons not selected" do
      invalid_fields = validate_radio_field("outside_uk_participants", radio: "", other: "")
      expect(invalid_fields).to eq [{ text: "Select yes if the project has partners or participants outside the UK" }]
    end
  end
end