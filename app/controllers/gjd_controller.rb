class GjdController < ApplicationController
  def getjobdetails
    if params[:jobid]
      require "net/http"
      require "uri"
      uri = URI.parse("https://jobs.apple.com/us/requisition/detail.json")

      # Full
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri)request.body = "requisitionId=#{params[:jobid]}&reqType=REQ&clientOffset=-300"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      response = http.request(request)
      # response.body
      # # response.status
      # @response = "test"
      # @response = response.body.length
      @response = response.body
    end
  end
end
