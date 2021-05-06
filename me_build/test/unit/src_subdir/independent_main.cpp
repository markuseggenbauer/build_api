#include <thread>

int main() {
  int array[2] = {0, 0};

  // concurrency violation
  auto thread = std::thread([&]() { array[0] = 1; });
  auto new_value = array[0];

  thread.join();

  // Address access violation
  return array[2];
}
