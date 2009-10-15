package
{
  import mx.controls.treeClasses.TreeItemRenderer;
  
  import mx.controls.Image;
  import mx.controls.Text;
  
  import mx.events.ResizeEvent;
    
  public class CustomTreeItemRenderer extends TreeItemRenderer
  {
    protected var iconImage:Image;
    protected var description:Text;		
		
    public function CustomTreeItemRenderer() 
    {
      super();
      mouseEnabled = false;
    }
        
    override protected function createChildren():void
    {
      super.createChildren();
      
      //Setting this keeps the label field from jumping around on resizes
      setStyle( "verticalAlign", "top" );
      
      iconImage = new Image();
      iconImage.setStyle( "verticalAlign", "middle" );
      addChild( iconImage );

      description = new Text();
      
      addChild( description );
    }
        
    // Override the set method for the data property
    // to set the font color and style of each node.
    override public function set data(value:Object):void 
    {
    	if ( value == null || value.length == 0 ) return;
    	
      super.data = value;
  
      if ( this.parent == null ) return;
      
      //Setup the source and the height and width of the
      //icon image
    	iconImage.source = String(super.data.icon_src);
      iconImage.width = super.data.icon_width;
  	  iconImage.height = super.data.icon_height;
  
      description.htmlText =  super.data.description;
  
      invalidateDisplayList();
    }
      
    override protected function measure():void
    {
      super.measure();
      
      //We add the height of the Text field to the calculated height of the renderer
      measuredHeight = measuredMinHeight = measuredHeight + description.getExplicitOrMeasuredHeight(); 
    }
     
    // Override the updateDisplayList() method 
    // to set the text for each tree node.        
    override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void 
    {
      super.updateDisplayList( unscaledWidth, unscaledHeight );
      
      if( super.data ) 
      {
        //This resolves the apparent bug in the Tree component
        //If the calculated height of the renderer doesn't match what gets passed to this 
        //method, we need to tell the Tree to re-layout the renderers
        if ( unscaledHeight != measuredHeight )
          dispatchEvent( new RendererResizeEvent( RendererResizeEvent.RENDERER_RESIZE, true, true ) );
        
        //Set the label to our title data field
        super.label.text = super.data.title;
        
        // Position the icon image where the label is currently positioned
      	iconImage.x = super.label.x;
      	
      	//Move the label over beside the icon with a space of 2
      	super.label.x = iconImage.x + iconImage.width + 2;
      	
      	//Position the description under the label text.
      	//We use super.label.textHeight instead of super.label.height 
      	//because super.label.height is the height of the renderer
      	description.x = super.label.x;
      	description.y = super.label.y + super.label.textHeight;
      	
      	//This forces the Text component to calculate it's height
      	description.width = width - description.x;
      	
      	//This sets the Text component to the calculated width & height
        description.setActualSize( description.getExplicitOrMeasuredWidth(), description.getExplicitOrMeasuredHeight() );
      }
    }
  }
}