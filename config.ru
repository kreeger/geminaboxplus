require "./boot"

class Geminabox
  private
  def reindex(force_rebuild = false)
    Geminabox.fixup_bundler_rubygems!
    force_rebuild = true unless settings.incremental_updates
    Resque.enqueue(Reindexer, settings.data, force_rebuild)
  end
end

run Rack::URLMap.new("/" => Geminabox, "/resque" => Resque::Server.new)
