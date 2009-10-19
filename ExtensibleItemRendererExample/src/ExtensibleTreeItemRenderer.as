package
{
  import mx.controls.listClasses.ListBase;
  import mx.controls.treeClasses.TreeItemRenderer;
  import mx.core.IDeferredInstance;
  import mx.core.UIComponent;
  import mx.events.FlexEvent;

  public class ExtensibleTreeItemRenderer extends TreeItemRenderer
  {
    //We use a deferred instance to cause component instantiation
    //to be deferred until it is needed
    [InstanceType("mx.core.UIComponent")]
    public var contents:IDeferredInstance;
    
    public function ExtensibleTreeItemRenderer()
    {
      super();
      
      //On initialize, add the custom contents to the renderer
      addEventListener(FlexEvent.INITIALIZE, handleInitialize, false, 0, true );
    }
    
    private function handleInitialize( evt:FlexEvent ):void
    {
      if ( contents ) addChild( UIComponent(contents.getInstance()) );
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      //hide the default label
      label.visible = false;
    }
    
    override protected function measure():void
    {
      super.measure();
      
      //The height of the renderer is set to the height of the contents
      if ( contents ) measuredHeight = measuredMinHeight = UIComponent(contents.getInstance()).getExplicitOrMeasuredHeight();
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList( unscaledWidth, unscaledHeight );

      if( super.data ) 
      {
        if ( contents )
        {
          //Position the contents using the position of the label
          UIComponent(contents.getInstance()).x = label.x;
          UIComponent(contents.getInstance()).y = label.y;
          
          //TForces the contents to calculate height by setting the width
          UIComponent(contents.getInstance()).width = width - UIComponent(contents.getInstance()).x;

          //This sets the components actual size to the calculated width & height
          UIComponent(contents.getInstance()).setActualSize( UIComponent(contents.getInstance()).getExplicitOrMeasuredWidth(), UIComponent(contents.getInstance()).getExplicitOrMeasuredHeight() );
          
          //This resolves an (apparent) bug in the ListBase component
          //If the calculated height of the renderer doesn't match what gets passed to this 
          //method, we need to tell the Tree to re-layout the renderers
          if ( unscaledHeight != measuredHeight && name != "hiddenItem" )  callLater( ListBase(owner).invalidateList );
        }
      }
    }
  }
}