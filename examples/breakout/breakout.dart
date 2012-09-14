
#import('dart:html');
#import('../../broadside.dart');
num ballSize=10;
num brickWidth=20;
num brickHeight=10;
num brickCountX=20;
num brickSepX=5;
num brickCountY=10;
num brickSepY=5;
num ballSpeed=1;
num paddleWidth=30;
num paddleHeight=10;
num paddleDx=10;
class Ball{
  Rectangle shape;
  Vector velocity;
  Collider collider;
  Ball(Vector point){
    shape=new Rectangle.fromPointAndSize(point,new Size(ballSize,ballSize));
    velocity=new Vector(ballSpeed,ballSpeed);
  }
  Drawable getDrawable(){
    return new FilledRectangle(shape);
  }
}
class Brick{
  Rectangle shape;
  Collider collider;
  Brick.fromIndex(int x,int y){
    shape=new Rectangle.fromPointAndSize(
        new Vector((brickWidth+brickSepX)*x,
            (brickHeight+brickSepY)*y),new Size(brickWidth,brickHeight));
  }
  Drawable getDrawable(){
    return new FilledRectangle(shape);
  }
}
class Paddle{
  Rectangle shape;
  Vector velocity;
  Collider collider;
  Paddle(Vector point){
    shape=new Rectangle.fromPointAndSize(point, new Size(paddleWidth,paddleHeight));
    velocity=new Vector(0,0);
  }
  Drawable getDrawable(){
    return new FilledRectangle(shape);
  }
}
List bricks;
Ball ball;
Group world;
Paddle paddle;
CollisionSystem coll=new CollisionSystem(new RectangleBinaryCollision(),false);
TypeTree typeTree=new TypeTree(new TypeNode("root"));
TypeNode ballType=new TypeNode("ball");
TypeNode brickType=new TypeNode("brick");
TypeNode paddleType=new TypeNode("paddle");
void main(){
  window.on.keyDown.add(keyDown);
  window.on.keyUp.add(keyUp);
  window.on.keyPress.add(keyPress);
  
  
  
  world=new Group(new List());
  bricks=new List();
  tabulate(brickCountX,
      (x)=>
          tabulate(brickCountY,
              (y)=>
                  bricks.add(new Brick.fromIndex(x,y))));
  
  bricks.forEach((brick){
    world.elements.add(brick.getDrawable());
    brick.collider=coll.register(brick,brick.shape,brickType);
  });
  
  ball=new Ball(new Vector(200,100));
  world.elements.add(ball.getDrawable());
  ball.collider=coll.register(ball,ball.shape,ballType);
  
  paddle=new Paddle(new Vector(200,200));
  world.elements.add(paddle.getDrawable());
  paddle.collider=coll.register(paddle,paddle.shape,paddleType);
  
  new TimeoutTimer()
  ..interval = 100
  ..action = onFrame
  ..start();
}
void keyDown(Event e){
  e.preventDefault();
  if(e is KeyboardEvent){
    KeyboardEvent ke=e;
    if(ke.keyIdentifier=="Left"){
      paddle.velocity.x=-paddleDx;
    }else if(ke.keyIdentifier=="Right"){
      paddle.velocity.x=paddleDx;
    }
  }
}
void keyUp(Event e){
  e.preventDefault();
  if(e is KeyboardEvent){
    KeyboardEvent ke=e;
    if(ke.keyIdentifier=="Left"){
      paddle.velocity.x=0;
    }else if(ke.keyIdentifier=="Right"){
      paddle.velocity.x=0;
    }
  }
}
void keyPress(Event e){
  e.preventDefault();
  if(e is KeyboardEvent){
    KeyboardEvent ke=e;
    
  }
}
void onFrame(){
  ball.shape.point.add(ball.velocity);
  paddle.shape.point.add(paddle.velocity);
  ball.collider.getCollisions(brickType);
  render("#breakout",world);
}