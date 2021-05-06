#include <thread>

int main() {
  int array[2] = {0, 0};
  int array_2[2] = {0, 0};

  auto thread = std::thread([&]() { array[0] = 1; });
  auto new_value = array[0];

  thread.join();
  return array[2];
}
