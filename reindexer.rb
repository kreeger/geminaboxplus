class Reindexer
  @queue = :reindex

  def self.perform(data, force_rebuild)
    Gem.post_reset { Gem::Specification.all = nil }

    indexer = Gem::Indexer.new(data)
    dependency_cache = Geminabox::DiskCache.new(File.join(settings.data, "_cache"))

    if force_rebuild
      indexer.generate_index
      dependency_cache.flush
    else
      begin
        require 'geminabox/indexer'
        updated_gemspecs = Geminabox::Indexer.updated_gemspecs(indexer)
        Geminabox::Indexer.patch_rubygems_update_index_pre_1_8_25(indexer)
        indexer.update_index
        updated_gemspecs.each { |gem| dependency_cache.flush_key(gem.name) }
      rescue => e
        puts "#{e.class}:#{e.message}"
        puts e.backtrace.join("\n")
        perform(indexer, true)
      end
    end
  end
end
