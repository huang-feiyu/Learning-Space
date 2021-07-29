#ifndef TESTFORPROJECT1_LRUREPLACER_H
#define TESTFORPROJECT1_LRUREPLACER_H
#ifndef TESTFORPROJECT1_LRUREPLACER_H
#define TESTFORPROJECT1_LRUREPLACER_H
//===----------------------------------------------------------------------===//
//
//                         BusTub
//
// lru_replacer.h
//
// Identification: src/include/buffer/lru_replacer.h
//
// Copyright (c) 2015-2019, Carnegie Mellon University Database Group
//
//===----------------------------------------------------------------------===//
#pragma once

#include <mutex>  // NOLINT
#include <unordered_map>
#include <memory>

#include "buffer/replacer.h"
#include "common/config.h"

namespace bustub {
/**
 * LRUReplacer implements the lru replacement policy, which approximates the Least Recently Used policy.
 */
    class LRUReplacer : public Replacer {
        // Doubly Linked list
        struct Node {
            Node() {}

            explicit Node(frame_id_t v) : value(v) {}

            frame_id_t value;
            std::shared_ptr<Node> prev;
            std::shared_ptr<Node> next;
        };

    public:
        /**
         * Create a new LRUReplacer.
         * @param num_pages the maximum number of pages the LRUReplacer will be required to store
         */
        explicit LRUReplacer(size_t num_pages);

        /**
         * Destroys the LRUReplacer.
         */
        ~LRUReplacer() override;

        // Remove the object that was accessed the least recently compared to all the
        // elements being tracked by the Replacer, store its contens in the output
        // parameter and return TRUE. If the Replacer is empty return FALSE
        bool Victim(frame_id_t *frame_id) override;

        // This method should be called after a page is pinned to a frame in the
        // BufferPoolManager. It should remove the frame containing the pinned page
        // from the LRUReplacer
        void Pin(frame_id_t frame_id) override;

        // This method should be called when the pin_count of a page becomes 0. This
        // method should add the frame containing the unpinned page to the LRUReplacer
        void Unpin(frame_id_t frame_id) override;

        // This method returns the number of frames that are currently in the
        // LRUReplacer
        size_t Size() override;

    private:
        // local variables
        size_t capacity;
        size_t count;
        std::shared_ptr<Node> head_;
        std::shared_ptr<Node> tail_;
        std::unordered_map<frame_id_t, std::shared_ptr<Node>> hashmap_;
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
            count++;
            return true;
        }

        // remove the tail
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

    /**
 * Create a new LRUReplacer.
 * @param num_pages the maximum number of pages the LRUReplacer will be required to store
 */
    LRUReplacer::LRUReplacer(size_t num_pages) {
        capacity = num_pages;
        // no pages in the list
        count = 0;
        // assign meaningless value to head and tail
        // You may need to avoid many LRUReplacers
        head_ = std::make_shared<Node>(-1);
        tail_ = std::make_shared<Node>(-1);
        head_->next = tail_;
        tail_->prev = head_;
    }

/**
 * Destroys the LRUReplacer.
 */
    LRUReplacer::~LRUReplacer() = default;

// Remove the object that was accessed the least recently compared to all the
// elements being tracked by the Replacer, store its contens in the output
// parameter and return TRUE. If the Replacer is empty return FALSE
    bool LRUReplacer::Victim(frame_id_t *frame_id) {
        std::scoped_lock lru_lck(latch_);
        if (count == 0) {
            return false;
        }
        *frame_id = tail_->prev->value;
        return Remove(tail_->prev);
    }

// This method should be called after a page is pinned to a frame in the
// BufferPoolManager. It should remove the frame containing the pinned page
// from the LRUReplacer
    void LRUReplacer::Pin(frame_id_t frame_id) {
        std::scoped_lock lru_lck(latch_);
        if (count == 0 || hashmap_.count(frame_id) == 0) {
            return;
        }
        std::shared_ptr<Node> node = hashmap_[frame_id];
        Remove(node);
    }

// This method should be called when the pin_count of a page becomes 0. This
// method should add the frame containing the unpinned page to the LRUReplacer
    void LRUReplacer::Unpin(frame_id_t frame_id) {
        std::scoped_lock lru_lck(latch_);
        if (hashmap_.count(frame_id) == 1) {
            return;
        }
        if (count == capacity) {
            Remove(tail_->prev);
        }
        std::shared_ptr<Node> node = std::make_shared<Node>(frame_id);
        Insert(node);
    }

// This method returns the number of frames that are currently in the
// LRUReplacer
    size_t LRUReplacer::Size() {
        return count;
    }


}  // namespace bustub
#endif //TESTFORPROJECT1_LRUREPLACER_H


#endif //TESTFORPROJECT1_LRUREPLACER_H
