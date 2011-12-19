module IndexHelper
  class IndexBuilder
    attr_reader :columns, :records, :model
    
    def initialize template, model, records, options={}, &block
      @template = template
      @model = model
      @records = records
      @columns = [] # TODO initialize from Array?
      @options = options
      
      yield(self) if block_given?
    end
    
    def column name, title=nil, &block
      @columns << IndexColumn.new(@template, @model, name, &block)
    end
    
    def title
      @options[:title] || model.model_name.human
    end
    
    def model_path(*args)
      send("#{model.model_name}_path", args)
    end
    
  end
  
  class IndexColumn
    attr_reader :name, :title
    
    def initialize template, model, name, title=nil, &block
      @model = model
      @template = template
      @value_block = block if block_given?
      @name = name
      @title = title
      @title ||= @model.try(:human_attribute_name, name)
      @title ||= name
    end
      
    def head
      @title
    end
      
    def body record
      if @value_block
        value = (@template.with_output_buffer{ @value_block.yield (record)} )
      end
      value ||= record.try(@name)
      value.to_s
    end
  end
    
  def index model, records, options={}, &block
    if params[:sort].present? && model.columns_hash.include?(params[:sort])
      sort = params[:sort]
      order = params[:order] if params[:order].present? && [:asc, :desc].include?(params[:order].to_sym)
      records = records.order("#{sort} #{order}")
    end
    
    records = records.page(params[:page]).per(5) unless options[:pagination] == false
    
    builder = IndexBuilder.new(self, model, records, options, &block)
    render partial: 'helpers/index', locals: { builder: builder, options: options }
  end
end