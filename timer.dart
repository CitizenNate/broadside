
typedef void callback();
class Timer{
  abstract void start();
  abstract void set action(callback action);
  abstract void set interval(int ms);
  abstract void stop();
}
class TimeoutTimer implements Timer{
  callback action;
  int interval=100;
  bool active=false;
  TimeoutTimer(){
    action=(){};
  }
  void start(){
    if(!active){
      active=true;
      next();
    }
  }
  void next(){
    if(active){
      action();
      window.setTimeout(next,interval);
    }
  }
  void stop(){
    //TODO do better
    active=false;
  }
}
