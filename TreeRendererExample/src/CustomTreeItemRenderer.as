package
{
  import mx.controls.treeClasses.TreeItemRenderer;
  
  import mx.controls.Image;
  import mx.controls.Tree;
  import mx.controls.Text;
  
  import mx.events.ResizeEvent;
    
  public class CustomTreeItemRenderer extends TreeItemRenderer
  {
    protected var _tree:Tree;
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
      
      if ( _tree == null )
      {
        _tree = Tree(this.parent.parent);
        _tree.addEventListener(ResizeEvent.RESIZE, function( evt:ResizeEvent ):void
        {
          //We must unset the height and width of the text field or it won't re-measure
          //and won't resize properly
          description.explicitWidth = NaN;
          description.explicitHeight = NaN;
        });
      }
  
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
      
      //Setting the width of the description field
      //causes the height calculation to happen
      description.width = explicitWidth - super.label.x;
      
      //We add the measuredHeight to the renderers measured height
      measuredHeight += description.measuredHeight;
    }
     
    // Override the updateDisplayList() method 
    // to set the text for each tree node.        
    override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void 
    {
      super.updateDisplayList( unscaledWidth, unscaledHeight );
      
      if( super.data ) 
      {
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
      	
      	//If we don't set the height the text doesn't display. But if we do this
      	//in measure(), it screws up the height of the renderer
      	description.height = description.measuredHeight;
      }
    }
  }
}