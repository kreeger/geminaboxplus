class Reindexer
  @queue = :reindex

  def self.perform(data, force_rebuild)
    Gem.post_reset{ Gem::Specification.all = nil }
    indexer = Gem::Indexer.new(data)

    begin
      indexer.generate_index
    rescue => e
      puts "#{e.class}:#{e.message}"
      puts e.backtrace.join("\n")
      perform(indexer, true)
    end
  end
end
