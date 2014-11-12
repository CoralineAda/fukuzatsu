module Fukuzatsu

  class Summary

    attr_reader :entity, :source_file, :container
    attr_accessor :edges, :nodes, :exits, :summaries

    BRANCHES = [
      :if,
      :or_asgn,
      :and_sgn,
      :or,
      :and
    ]

    def self.from(content:, source_file:nil)
      parser = Analyst.for_source(content)

      containers = parser.top_level_entities.select{|e| e.respond_to? :all_methods}
      containers << containers.map(&:classes)
      containers.flatten!.reject!{ |container| container.all_methods.empty? }

      containers.map do |container|
        summary = Fukuzatsu::Summary.new(
          container: container,
          source: container.send(:source),
          entity: container,
          source_file: source_file
        )
        summary.summaries = container.all_methods.map do |method|
          Fukuzatsu::Summary.new(
            container: container,
            source: method.send(:source),
            entity: method,
            source_file: source_file
          )
        end
        summary
      end
    end

    def initialize(source:, entity:, container:, source_file:nil, summaries:[])
      @source = source
      @entity = entity
      @container = container
      @source_file = source_file
      @summaries = summaries
      @edges, @nodes, @exits = [0, 1, 1]
    end

    def complexity
      @complexity ||= begin
        traverse(self.entity.ast)
        self.edges - self.nodes + self.exits
      end
    end

    def container_name
      self.container.full_name
    end

    def is_class_or_module?
      self.container == self.entity
    end

    def entity_name
      return "*" if is_class_or_module?
      self.entity.full_name.gsub(self.container.full_name, '')
    end

    def average_complexity
      return 0 if self.summaries.blank?
      self.summaries.map(&:complexity).reduce(&:+) / self.summaries.count.to_f
    end

    def raw_source
      self.source_file && "\n#{File.open(self.source_file, "r").read}" || @source
    end

    private

    def extend_graph
      self.edges += 2
      self.nodes += 2
      self.exits += 1
    end

    def traverse(node, accumulator=[])
      accumulator << node.type
      extend_graph if BRANCHES.include?(node.type)
      node.children.each do |child|
        if child.respond_to?(:children) || child.respond_to?(:type)
          accumulator << child.type
          traverse(child, accumulator)
        end
      end
      accumulator
    end
  end

end