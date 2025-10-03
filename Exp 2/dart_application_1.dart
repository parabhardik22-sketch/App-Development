import 'dart:io';

void main() {
  // Taking input
  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();

  stdout.write("Enter a number: ");
  int num = int.parse(stdin.readLineSync()!);

  // Output
  print("Hello, $name!");
  print("You entered: $num");

  // For loop
  print("\nFor loop from 1 to $num:");
  for (int i = 1; i <= num; i++) {
    print("i = $i");
  }

  // While loop
  print("\nWhile loop countdown:");
  int count = num;
  while (count > 0) {
    print(count);
    count--;
  }

  // Do-while loop
  print("\nDo-while loop runs at least once:");
  int x = 0;
  do {
    print("x = $x");
    x++;
  } while (x < 3);
}
