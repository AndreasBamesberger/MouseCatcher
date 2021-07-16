// TODO: harder difficulty: follower goes toward center between cursor and food

class Cursor {
  int diameter = 20;
  PImage cursor_symbol;

  Cursor() {
    cursor_symbol = loadImage("../player.png");
    cursor_symbol.resize(diameter, diameter);
    cursor(cursor_symbol);
  }
}

class Follower {
  int colour = #96C465;
  int d = 50;
  float x = 500, y = 500;
  float distance;
  PShape symbol;

  Follower() {
    fill(colour);
    symbol = createShape(ELLIPSE, x, y, d, d);
  }
}

Cursor cursor;
Follower follower;

int colour_text = #2C6226;
int colour_follower = #96C465;
int colour_food = #0909FF;
int colour_background = #3D3C3E;

int field_width = 1000;
int field_height = 800;

PImage cursor_symbol;
PShape follower_symbol;
PShape food_symbol;

int food_diameter = 20;
int follower_diameter = 50;
int cursor_diameter = 20;

float food_x, food_y;
float follower_x = 500, follower_y = 500;
PVector target;

float distance_food;
float distance_follower;

float velocity_start = 3;
float velocity = velocity_start;
int food_count = 0;

boolean game_over = false;

void print_debug() {
  textSize(20);
  fill(colour_text);
  int text_y = 20;
  text("mouse_x = " + mouseX, 10, text_y);
  text_y += 20;
  text("mouse_y = " + mouseY, 10, text_y);
  text_y += 20;
//  text("follower.x = " + follower.x, 10, text_y);
  text("follower_x = " + follower_x, 10, text_y);
  text_y += 20;
//  text("follower.y = " + follower.y, 10, text_y);
  text("follower_y = " + follower_y, 10, text_y);
  text_y += 20;
  text("target.x = " + target.x, 10, text_y);
  text_y += 20;
  text("target.y = " + target.y, 10, text_y);
  text_y += 20;
  text("distance_food = " + distance_food, 10, text_y);
  text_y += 20;
//  text("follower.distance = " + follower.distance, 10, text_y);
  text("distance_follower = " + distance_follower, 10, text_y);
  text_y += 20;
  text("velocity = " + velocity, 10, text_y);
  text_y += 20;
  text("food_count = " + food_count, 10, text_y);
}

void change_cursor() {
  // set up cursor 
  cursor_symbol = loadImage("../player.png");
  cursor_symbol.resize(cursor_diameter, cursor_diameter);
  cursor(cursor_symbol);
}

void create_follower() {
  // set up follower
  fill(colour_follower);
  follower_symbol = createShape(ELLIPSE, follower_x, follower_y, 
                                follower_diameter, follower_diameter);
}

void create_food() {
  fill(0, 0, 255);
  food_x = random(food_diameter, field_width - food_diameter * 2);
  food_y = random(food_diameter, field_height - food_diameter * 2);

  food_symbol = createShape(ELLIPSE, food_x, food_y, 20, 20);
}

void follow() {
  // get vector from follower to cursor
  target = new PVector(mouseX - follower_x, 
                       mouseY - follower_y);
  target.normalize();

  follower_symbol.translate(target.x * velocity, 
                            target.y * velocity);
  follower_x += target.x * velocity;
  follower_y += target.y * velocity;
}

boolean detect_collision(PShape test_object) {
  float x = -1, y = -1, diameter = -1, distance = -1;
  // TODO: try out a switch here
  if (test_object == follower_symbol) {
    x = follower_x;
    y = follower_y;
    diameter = follower_diameter / 2;
    distance = dist(mouseX, mouseY, x, y);
    distance_follower = distance;
  }
  else if (test_object == food_symbol) {
    x = food_x;
    y = food_y;
    diameter = food_diameter / 2;
    distance = dist(mouseX, mouseY, x, y);
    distance_food = distance;

  }
  
  // TODO: if x, y, diameter < 0: error
  
  if (distance < diameter) {
    return true;
  }
  else {
    return false;
  }
  
}

void keyPressed() {
  if (int(key) == 32) {
    game_over = false;
  }
  //println("pressed " + int(key) + " " + keyCode);
}
/*
void keyTyped() {
  println("typed " + int(key) + " " + keyCode);
}

void keyReleased() {
  println("released " + int(key) + " " + keyCode);
}
*/

void setup() {
  size(1000, 800);
  frameRate(60);
  
  change_cursor();
  create_follower();
  create_food();
}

void draw() {
  if (!game_over) {
    background(colour_background);
  
    shape(follower_symbol);
    shape(food_symbol);
  
    follow();
    
    boolean took_food = detect_collision(food_symbol);
    boolean caught = detect_collision(follower_symbol);
    
    if (took_food) {
      create_food();
      food_count += 1;
      velocity += 0.3;
    }
    
    if (caught) {
      game_over = true;
      food_count = 0;
      velocity = velocity_start;
      fill(colour_text);
      text("Game over. Press Spacebar to play again.", 300, 300);
    }
  
    print_debug();
  }
}
