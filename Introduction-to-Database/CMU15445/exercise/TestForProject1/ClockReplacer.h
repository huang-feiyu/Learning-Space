#ifndef TESTFORPROJECT1_CLOCKREPLACER_H
#define TESTFORPROJECT1_CLOCKREPLACER_H
//===----------------------------------------------------------------------===//
//
//                         BusTub
//
// clock_replacer.h
//
// Identification: src/include/buffer/clock_replacer.h
//
// Copyright (c) 2015-2019, Carnegie Mellon University Database Group
//
//===----------------------------------------------------------------------===//

#pragma once

#include <mutex>  // NOLINT
#include <memory>
#include <unordered_map>


namespace bustub {
    // Circle Linked list
    struct Node {
        Node() {}
        Node(int v) : value(v), ref(1) {}
        int value;
        bool ref;
        std::shared_ptr<Node> prev;
        std::shared_ptr<Node> next;
    };
/**
 * ClockReplacer implements the clock replacement policy, which approximates the Least Recently Used policy.
 */
    class ClockReplacer {
    public:
        /**
         * Create a new ClockReplacer.
         * @param num_pages the maximum number of pages the ClockReplacer will be required to store
         */
        explicit ClockReplacer(size_t num_pages);

        /**
         * Destroys the ClockReplacer.
         */
        ~ClockReplacer();

        bool Victim(int *frame_id);

        void Pin(int frame_id);

        void Unpin(int frame_id);

        size_t Size();

    private:
        // local variables
        size_t capacity;
        size_t count;
        std::shared_ptr<Node> head_;
        std::shared_ptr<Node> tail_;
        std::unordered_map<int, std::shared_ptr<Node>> hashmap_;
        mutable std::mutex latch_;

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
    };
    ClockReplacer::ClockReplacer(size_t num_pages) {
        head_ = std::make_shared<Node>(-1);
        tail_ = std::make_shared<Node>(-1);
        capacity = num_pages;
        count = 0;
        head_->next = tail_;
        tail_->prev = head_;
    }

    ClockReplacer::~ClockReplacer() = default;

    bool ClockReplacer::Victim(int *frame_id) {
        std::scoped_lock lru_lck(latch_);
        if (count == 0) {
            return false;
        }
        std::shared_ptr<Node> node = tail_->prev;
        // ref = true
        while (node->ref) {
            node->ref = false;
            node = node->prev;
        }
        if (node->value != -1) {
            *frame_id = node->value;
            return Remove(node);
        }
        // header node
        node->ref = true;
        return false;
    }

    void ClockReplacer::Pin(int frame_id) {
        std::scoped_lock lru_lck(latch_);
        if (count == 0 || hashmap_.count(frame_id) == 0) {
            return;
        }
        std::shared_ptr<Node> node = hashmap_[frame_id];
        Remove(node);
    }

    void ClockReplacer::Unpin(int frame_id) {
        std::scoped_lock lru_lck(latch_);
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

    size_t ClockReplacer::Size() {
        return count;
    }
}  // namespace bustub


#endif //TESTFORPROJECT1_CLOCKREPLACER_H
