#include <iostream>
#include <memory>
#include <unordered_map>

using namespace std;

// Circle Linked list
struct Node {
    Node() {}

    Node(int v) : value(v), ref(false) {}

    int value;
    bool ref;
    std::shared_ptr<Node> prev;
    std::shared_ptr<Node> next;
};

bool Victim(int *frame_id);

void Pin(int frame_id);

void Unpin(int frame_id);

size_t Size();

size_t capacity;
size_t count;
std::shared_ptr<Node> head_;
std::shared_ptr<Node> tail_;
std::unordered_map<int, std::shared_ptr<Node>> hashmap_;

// local private methods
// insert Node at head
bool Insert(std::shared_ptr<Node> node) {
    if (node == nullptr) {
        return false;
    }
    // add to hashmap_
    hashmap_[node->value] = node;
    // add to first, head is just a non-value node
    node->next = head_->next;
    node->prev = head_;
    head_->next->prev = node;
    head_->next = node;
    node->ref = true;
    count++;
    return true;
}

// remove the specific node
bool Remove(std::shared_ptr<Node> node) {
    if (node == nullptr || hashmap_.count(node->value) == 0) {
        return false;
    }
    node = hashmap_[node->value];
    node->prev->next = node->next;
    node->next->prev = node->prev;
    hashmap_.erase(node->value);
    count--;
    return true;
}

void initialize(size_t num_pages) {
    head_ = std::make_shared<Node>(-1);
    tail_ = std::make_shared<Node>(-1);
    capacity = num_pages;
    count = 0;
    head_->ref = true;
    tail_->ref = true;
    head_->next = tail_;
    tail_->prev = head_;
}


bool Victim(int *frame_id) {
    if (count == 0) {
        return false;
    }
    std::shared_ptr<Node> node = tail_->prev;
    // ref = true
    while (node->ref) {
        node->ref = false;
        node = node->prev;
        if (node->value == -1) {
            break;
        }
    }
    if (node->value != -1) {
        *frame_id = node->value;
        return Remove(node);
    }
    // header node, every ref is true
    *frame_id = tail_->prev->value;
    Remove(tail_->prev);
    return true;
}

void Pin(int frame_id) {
    if (count == 0 || hashmap_.count(frame_id) == 0) {
        return;
    }
    std::shared_ptr<Node> node = hashmap_[frame_id];
    Remove(node);
}

void Unpin(int frame_id) {
    if (hashmap_.count(frame_id) == 1) {
        hashmap_[frame_id]->ref = true;
        return;
    }
    if (count == capacity) {
        int tmp;
        Victim(&tmp);
    }
    std::shared_ptr<Node> node = std::make_shared<Node>(frame_id);
    Insert(node);
}

int main(void) {
    initialize(5);
    Unpin(5);
    Unpin(4);
    Unpin(2);
    Unpin(6);
    shared_ptr<Node> node = tail_->prev;
    for (int i = 0; i < count; i++, node = node->prev) {
        cout << node->value << " " << node->ref << ", ";
    }
    cout << endl;
    int a;
    Victim(&a);
    cout << a << endl;
    node = tail_->prev;
    for (int i = 0; i < count; i++, node = node->prev) {
        cout << node->value << " " << node->ref << ", ";
    }
    cout << endl;

    Unpin(4);
    Unpin(5);
    Unpin(1);
    Unpin(7);
    node = tail_->prev;
    for (int i = 0; i < count; i++, node = node->prev) {
        cout << node->value << " " << node->ref << ", ";
    }
    cout << endl;

    Pin(5);
    node = tail_->prev;
    for (int i = 0; i < count; i++, node = node->prev) {
        cout << node->value << " " << node->ref << ", ";
    }
    cout << endl;
}