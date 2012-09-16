
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

  Vector getForwardPoint() {
    if(velocity.x<0){
      if(velocity.y<0){
        return shape.point;
      }else{
        return new Vector(shape.x,shape.y+shape.height);
      }
    }else{
      if(velocity.y<0){
        return new Vector(shape.x+shape.width,shape.y+shape.height);
      }else{
        return new Vector(shape.x+shape.width,shape.y+shape.height);
      }
    }
  }
}
class Brick{
  Rectangle shape;
  Collider collider;
  Drawable drawable;
  Brick.fromIndex(int x,int y){
    shape=new Rectangle.fromPointAndSize(
        new Vector((brickWidth+brickSepX)*x,
            (brickHeight+brickSepY)*y),new Size(brickWidth,brickHeight));
    drawable=new FilledRectangle(shape);
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
List<Brick> bricks;
Ball ball;
Group world;
Paddle paddle;
CollisionSystem coll;
TypeTree typeTree;
TypeNode ballType;
TypeNode brickType;
TypeNode paddleType;
void main(){
  coll=new CollisionSystem(new RectangleBinaryCollision(),false);
  typeTree=new TypeTree(new TypeNode("root"));
  ballType=new TypeNode("ball");
  brickType=new TypeNode("brick");
  paddleType=new TypeNode("paddle");
  typeTree.addClass(ballType);
  typeTree.addClass(brickType);
  typeTree.addClass(paddleType);
  
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
    world.elements.add(brick.drawable);
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
  List hit=ball.collider.getCollisions(brickType);
  if(hit.length>0){
    Rectangle union=
        listFold((r1,r2)=>r1.union(r2),
            hit.map((collider)=>collider.shape));
    print(union);
    
    
    hit.forEach((Collider brickCollider){
      Brick brick=brickCollider.owner;
      listRemove(bricks,brick);
      listRemove(world.elements,brick.drawable);
      brickCollider.unregister();
      print("Collided ${brickCollider.id}");
    });
  }
  render("#breakout",world);
}