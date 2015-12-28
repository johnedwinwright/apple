class GjiController < ApplicationController
  def getjobindex
    if params[:jobid]
      require "net/http"
      require "uri"
      uri = URI.parse("https://jobs.apple.com/us/search/search-result")

      # Full
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = "searchRequestJson=#{
      {
        :searchString => '', :jobType => 0, :sortBy => 'req_open_dt', :sortOrder => '1', :language => nil, :autocomplete => nil, :delta => 0, :numberOfResults => 0, :pageNumber => 0, :internalExternalIndicator => 0, :lastRunDate => 0, :countryLang => nil,
      :filters =>
      {
        :locations =>
        {
          :location =>
          [{
            :type => 0, :code => 'USA', :countryCode => nil, :cityCode => nil, :cityName =>nil
            }]
          },
          :languageSkills => nil, :jobFunctions => nil, :retailJobSpecs => nil, :businessLine => nil, :hiringManagerId => nil
        },
            :requisitionIds => nil
          }.to_json
          }
          &clientOffset=-300"

      request["Content-Type"] = "application/x-www-form-urlencoded"
      response = http.request(request)
      # response.body
      # # response.status
      # @response = "test"
      # @response = response.body.length
      @gjiresponse = response.body
      @gjirequest = request.body
    end
  end
end
