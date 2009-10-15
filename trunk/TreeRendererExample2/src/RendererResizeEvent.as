package
{
  import flash.events.Event;

  public class RendererResizeEvent extends Event
  {
    public static const RENDERER_RESIZE:String = "rendererResize";
    
    public function RendererResizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
    
    override public function clone():Event
    {
      return new RendererResizeEvent( type, bubbles, cancelable );
    }
  }
}