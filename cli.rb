# frozen_string_literal: true

require "thor"
require "./dmm.rb"

class CLI < Thor
  desc "dmm [ID] [PASSWORD]", "Reserve english talk of dmm.com"
  def dmm(id = nil, password = nil)
    id ||= ENV["DMMLOGINID"]
    password ||= ENV["DMMPASSWORD"]

    unless id && password
      puts <<~MESSAGE
        Please pass a 'id' and 'password' of DMM.com via arguments or environment variable 'DMMLOGINID' and 'DMMPASSWORD'.
      MESSAGE
      exit 1
    end

    DMM.run(id, password)
  end
end
