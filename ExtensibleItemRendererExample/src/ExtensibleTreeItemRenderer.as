package
{
  import mx.controls.listClasses.ListBase;
  import mx.controls.treeClasses.TreeItemRenderer;
  import mx.core.IDeferredInstance;
  import mx.core.UIComponent;
  import mx.events.FlexEvent;

  public class ExtensibleTreeItemRenderer extends TreeItemRenderer
  {
    [InstanceType("mx.core.UIComponent")]
    public var contents:IDeferredInstance;
    
    public function ExtensibleTreeItemRenderer()
    {
      super();
      
      addEventListener(FlexEvent.INITIALIZE, handleInitialize, false, 0, true );
    }
    
    private function handleInitialize( evt:FlexEvent ):void
    {
      if ( contents ) addChild( UIComponent(contents.getInstance()) );
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      label.visible = false;
    }
    
    override protected function measure():void
    {
      super.measure();
      
      if ( contents ) measuredHeight = measuredMinHeight = UIComponent(contents.getInstance()).getExplicitOrMeasuredHeight();
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList( unscaledWidth, unscaledHeight );
      
      if( super.data ) 
      {
        //This resolves the apparent bug in the Tree component
        //If the calculated height of the renderer doesn't match what gets passed to this 
        //method, we need to tell the Tree to re-layout the renderers
        if ( unscaledHeight != measuredHeight )  callLater( ListBase(owner).invalidateList );
        
        if ( contents )
        {
          UIComponent(contents.getInstance()).x = label.x;
          UIComponent(contents.getInstance()).y = label.y;
          
          //This forces the Text component to calculate it's height
          UIComponent(contents.getInstance()).width = width - UIComponent(contents.getInstance()).x;

          //This sets the Text component to the calculated width & height
          UIComponent(contents.getInstance()).setActualSize( UIComponent(contents.getInstance()).getExplicitOrMeasuredWidth(), UIComponent(contents.getInstance()).getExplicitOrMeasuredHeight() );
        }
      }
    }
  }
}