class PdfController < ApplicationController
  def menu
    redirect_to root_path unless params[:reference] == "pdf" || params[:reference] == "html" &&
                                 params[:disposition] == "inline" || params[:disposition] == "attachment"

    respond_to do |format|
      format.pdf do
        pdf = MenuPdf.new(root_url, reference: params[:reference])
        send_data pdf.render, filename: "caussa.pdf", disposition: params[:disposition]
      end
    end
  end
end
