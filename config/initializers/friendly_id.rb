# Rewrite the conflict method

module FriendlyId
  module Slugged
    def resolve_friendly_id_conflict(candidates)
      # candidates.first + friendly_id_config.sequence_separator + SecureRandom.uuid
      SecureRandom.uuid[0,7] + friendly_id_config.sequence_separator + candidates.first
    end
  end
end