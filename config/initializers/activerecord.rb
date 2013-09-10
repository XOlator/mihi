class UrlValidator < ActiveModel::EachValidator
  require 'addressable/uri'

  def validate_each(record, attribute, value)
    begin
      uri = Addressable::URI.parse(value)
      raise Addressable::URI::InvalidURIError unless ['http','https'].include?(uri.scheme)
    rescue Addressable::URI::InvalidURIError
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end
end

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end
end

class ActiveRecord::Base
  def self.valid_attribute?(attribute, value)
    instance = new
    instance[attribute] = value
    instance.valid?
    list_of_errors = instance.errors.messages[attribute]
    list_of_errors.blank?
  end
end