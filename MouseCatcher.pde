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
  float velocity;
  PVector target;

  Follower(int c, int d, float pos_x, float pos_y, float v) {
    colour = c;
    diameter = d;
    x = pos_x;
    y = pos_y;
    velocity = v;
  }
  
  void display() {
    fill(colour);
    symbol = createShape(ELLIPSE, x, y, diameter, diameter);
  }

  boolean detect_collision() {
    distance = dist(mouseX, mouseY, x, y);
    float rad_sum = (cursor.diameter + diameter) / 2;
    if (distance < rad_sum) {
      return true;
    }
    else {
      return false;
    }
  }

  void follow() {
    target = new PVector(mouseX - x, 
                         mouseY - y);
    target.normalize();

    follower.symbol.translate(target.x * velocity, 
                              target.y * velocity);
    follower.x += target.x * velocity;
    follower.y += target.y * velocity;
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
  boolean detect_collision() {
    distance = dist(mouseX, mouseY, x, y);
    float rad_sum = (cursor.diameter + diameter) / 2;
    if (distance < rad_sum) {
      return true;
    }
    else {
      return false;
    }
  }
}

int colour_text = #2C6226;
int colour_background = #3D3C3E;

int field_width = 1000;
int field_height = 800;
int frame_rate = 60;

int food_count = 0;
float vel_start = 3;

boolean game_over = false;

Follower follower = new Follower(#96C465, 50, 500, 500, vel_start);
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
  text("follower.target.x = " + follower.target.x, 10, text_y);
  text_y += 20;
  text("follower.target.y = " + follower.target.y, 10, text_y);
  text_y += 20;
  text("food.distance = " + food.distance, 10, text_y);
  text_y += 20;
  text("follower.distance = " + follower.distance, 10, text_y);
  text_y += 20;
  text("follower.velocity = " + follower.velocity, 10, text_y);
  text_y += 20;
  text("food_count = " + food_count, 10, text_y);
}

void keyPressed() {
  if (int(key) == 32) {
    game_over = false;
  }
}

void settings() {
  size(field_width, field_height);
}

void setup() {
  frameRate(frame_rate);
  
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
  
    follower.follow();
    
    // boolean took_food = food.detect_collision();
    // boolean caught = follower.detect_collision();    

    if (food.detect_collision()) {
      food.random_pos();
      food.display();
      food_count += 1;
      follower.velocity += 0.3;
    }
    
    if (follower.detect_collision()) {
      game_over = true;
      food_count = 0;
      follower.velocity = vel_start;
      fill(colour_text);
      text("Game over. Press Spacebar to play again.", 300, 300);
    }
  
    print_debug();
  }
}
