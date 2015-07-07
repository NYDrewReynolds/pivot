require 'spec_helper'

RSpec.describe PdfController, type: :controller do

  it "sends a reqeust for a pdf file attachment" do
    create(:item)

    get :menu, format: :pdf, disposition: "attachment"
    
    expect(response.body).to include("PDF")
    expect(response.headers["Content-Transfer-Encoding"]).to eq("binary")
    expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"caussa.pdf\"")
    expect(response.headers["Content-Type"]).to eq("application/pdf")
  end
end
