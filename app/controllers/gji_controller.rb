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
      @gjiresponse = response.body
      @gjirequest = request.body

      @doc = Nokogiri::XML("#{@gjiresponse}")

      @block = @doc.xpath("//jobId")

      @chld_class = @block.map do |node|
        node.children.class
      end

      @chld_class
      # => [Nokogiri::XML::NodeSet, Nokogiri::XML::NodeSet]
      # @chld_name = @block.map do |node|
      #   node.children.map { |n| [n.name] }
      # end

      @chld_name = @block.map do |node|
        node.children.map{|n| [n.text]}.compact
      end.compact

      @chld_name = @chld_name.flatten

      @gjirequest = "#{getjobdetails_path}?jobid=#{@chld_name.first}"

      @chld_name.each do |gjd|
        require "net/http"
        require "uri"
        uri = URI.parse("http://localhost:3000/gjd/getjobdetails?jobid=#{gjd}")
        http = Net::HTTP.new(uri.host, uri.port)
        request2 = Net::HTTP::Get.new(uri.request_uri)
        response2 = http.request(request2)
         @gjirequest = response.body
      end
    end
  end
end
