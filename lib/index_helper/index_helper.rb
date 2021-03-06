module IndexHelper
  class IndexBuilder
    attr_reader :columns, :records, :model, :buttons
    
    def initialize template, model, records, options={}, &block
      @template = template
      @model = [model] unless model.is_a? Array
      @model ||= model 
      @records = records
      @columns = [] # TODO initialize from Array?
      @options = options
      @buttons = []
      
      yield(self) if block_given?
    end
    
    def column name=nil, title=nil, &block
      @columns << IndexColumn.new(@template, @model, name, &block)
    end

    def button &block
      @buttons << (@template.with_output_buffer{ block.yield } )
    end
    
    def title
      @options[:title] || model.last.model_name.human
    end
  end
  
  class IndexColumn
    attr_reader :name, :title
    
    def initialize template, model, name=nil, title=nil, &block
      @model = model
      @template = template
      @value_block = block if block_given?
      @name = name
      @title = title
      @title ||= model.last.try(:human_attribute_name, name) if name
      @title ||= name
    end
      
    def head
      @title
    end
      
    def body record
      value = (@template.with_output_buffer{ @value_block.yield (record)} ) if @value_block.present?
      value ||= record.try(@name) if @name.present? && record.respond_to?(@name)
      value ||= ""
      value.to_s
    end
  end
    
  def index model, records, options={}, &block
    if params[:sort].present? && model.columns_hash.include?(params[:sort])
      sort = params[:sort]
      order = params[:order] if params[:order].present? && [:asc, :desc].include?(params[:order].to_sym)
      records = records.order("#{sort} #{order}")
    end
    
    records = records.page(params[:page]) unless options[:pagination] == false
    
    builder = IndexBuilder.new(self, model, records, options, &block)
    render partial: 'index_helper/index', locals: { builder: builder, options: options }
  end
end
