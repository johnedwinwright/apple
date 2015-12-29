class GjiController < ApplicationController
  def getjobindex
    if params[:jobid]
      require "net/http"
      require "uri"
      uri = URI.parse("https://jobs.apple.com/us/search/search-result")
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
      #
      # if response.message == "Not Found" && retry_counter < 3
      #   retry_counter += 1
      #   response3 = http3.request(request3)
      #   puts "#{gjrd}"
      #   puts "#{response3.message}"
      # elsif response3.message =="ok"
      #   retry_counter = 0
      # elsif retry_counter = 3
      #   retry_counter = 0
      # end
      puts "#{response.message}"
      @gjiresponse = response.body
      @gjirequest = request.body

      @doc = Nokogiri::XML("#{@gjiresponse}")

      @reqs = @doc.xpath("//requisition")
      @retail_job_id_list = @reqs.map do |node|
        node.xpath(".//jobId").text if node.xpath(".//jobTypeCategory").text == "Retail"
      end.compact

      @corp_job_id_list = @reqs.map do |node|
        node.xpath(".//jobId").text if node.xpath(".//jobTypeCategory").text != "Retail"
      end.compact

      retry_counter = 0

      @corp_job_id_list.each do |gjcd|
        uri = URI.parse("https://jobs.apple.com/us/requisition/detail.json")
        http2 = Net::HTTP.new(uri.host, uri.port)
        http2.use_ssl = true
        http2.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request2 = Net::HTTP::Post.new(uri.request_uri)
        request2.body = "requisitionId=#{gjcd}&reqType=REQ&clientOffset=-300"
        request2["Content-Type"] = "application/x-www-form-urlencoded"
        response2 = http2.request(request2)
        puts "#{gjcd}"
        puts "#{response2.message}"
        @gjirequest = response2.body
        if response2.message == "Not Found" && retry_counter < 3
          wait 1
          retry_counter += 1
          response3 = http2.request(request2)
          puts "#{gjcd}"
          puts "#{response2.message}"
        elsif response2.message =="ok"
          retry_counter = 0
        elsif retry_counter = 3
          retry_counter = 0
        end
      end

      puts "#{@retaildetail}"

      @retail_job_id_list.each do |gjrd|
        uri = URI.parse("https://jobs.apple.com/us/requisition/retaildetail.json")
        http3 = Net::HTTP.new(uri.host, uri.port)
        http3.use_ssl = true
        http3.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request3 = Net::HTTP::Post.new(uri.request_uri)
        request3.body = "requisitionId=#{gjrd}&reqType=PT&clientOffset=-300"
        request3["Content-Type"] = "application/x-www-form-urlencoded"
        response3 = http3.request(request3)
        puts "#{gjrd}"
        puts "#{response3.message}"
        @gjirequest = response3.body
        if response3.message == "Not Found" && retry_counter < 3
          wait 1
          retry_counter += 1
          response3 = http3.request(request3)
          puts "#{gjrd}"
          puts "#{response3.message}"
        elsif response3.message =="ok"
          retry_counter = 0
        elsif retry_counter = 3
          retry_counter = 0
        end
      end
    end
  end
end
