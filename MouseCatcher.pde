// TODO: harder difficulty: follower goes toward center between cursor and food

class Cursor {
  int diameter;
  PImage cursor_symbol;

  Cursor(int d) {
    diameter = d;
  }
  void load() {
    cursor_symbol = loadImage("player.png");
    cursor_symbol.resize(diameter, diameter);
  }
  void display() {
    cursor(cursor_symbol);
  }
}

class Follower {
  int colour;
  int diameter;
  float x;
  float y;
  float distance;
  PShape symbol;

  Follower(int c, int d, float pos_x, float pos_y) { //<>//
    colour = c;
    diameter = d;
    x = pos_x;
    y = pos_y;
  }
  
  void display() {
    fill(colour);
    symbol = createShape(ELLIPSE, x, y, diameter, diameter);
  }
}

class Food {
  int colour;
  PShape symbol;
  int diameter;
  float x; 
  float y;
  float distance;

  Food(int c, int d) {
    colour = c;
    diameter = d;
    random_pos();
  }
  
  void display() {
    fill(colour);
    symbol = createShape(ELLIPSE, x, y, 20, 20);
  }
  
  void random_pos() {
    x = random(diameter, field_width - diameter * 2);
    y = random(diameter, field_height - diameter * 2);
  }
}

int colour_text = #2C6226;
int colour_background = #3D3C3E;

int field_width = 1000;
int field_height = 800;

PVector target;

float velocity_start = 3;
float velocity = velocity_start;
int food_count = 0;

boolean game_over = false;

Follower follower = new Follower(#96C465, 50, 500, 500);
Food food = new Food(#0909FF, 20);
Cursor cursor = new Cursor(20);

void print_debug() {
  textSize(20);
  fill(colour_text);
  int text_y = 20;
  text("mouse_x = " + mouseX, 10, text_y);
  text_y += 20;
  text("mouse_y = " + mouseY, 10, text_y);
  text_y += 20;
  text("follower.x = " + follower.x, 10, text_y);
  text_y += 20;
  text("follower.y = " + follower.y, 10, text_y);
  text_y += 20;
  text("target.x = " + target.x, 10, text_y);
  text_y += 20;
  text("target.y = " + target.y, 10, text_y);
  text_y += 20;
  text("food.distance = " + food.distance, 10, text_y);
  text_y += 20;
  text("follower.distance = " + follower.distance, 10, text_y);
  text_y += 20;
  text("velocity = " + velocity, 10, text_y);
  text_y += 20;
  text("food_count = " + food_count, 10, text_y);
}

void follow() {
  // get vector from follower to cursor
  target = new PVector(mouseX - follower.x, 
                       mouseY - follower.y);
  target.normalize();

  follower.symbol.translate(target.x * velocity, 
                            target.y * velocity);
  follower.x += target.x * velocity;
  follower.y += target.y * velocity;
}

boolean detect_collision(PShape test_object) {
  float x = -1, y = -1, diameter = -1, distance = -1;
  // TODO: try out a switch here
  if (test_object == follower.symbol) {
    x = follower.x;
    y = follower.y;
    diameter = follower.diameter / 2;
    distance = dist(mouseX, mouseY, x, y);
    follower.distance = distance;
  }
  else if (test_object == food.symbol) {
    x = food.x;
    y = food.y;
    diameter = food.diameter / 2;
    distance = dist(mouseX, mouseY, x, y);
    food.distance = distance;

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
}

void setup() {
  size(1000, 800);
  frameRate(60);
  
  cursor.load();
  cursor.display();

  follower.display();
  food.display();
}

void draw() {
  if (!game_over) {
    background(colour_background);
  
    shape(follower.symbol);
    shape(food.symbol);
  
    follow();
    
    boolean took_food = detect_collision(food.symbol);
    boolean caught = detect_collision(follower.symbol);
    
    if (took_food) {
      food.random_pos();
      food.display();
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
