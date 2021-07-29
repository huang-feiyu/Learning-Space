#pragma once

#include <utility>
#include <memory>

namespace bustub {
template <typename T>
class Matrix {
 protected:
  Matrix(int r, int c) : rows(r), cols(c), linear(new T[r * c]) {}

  int rows;
  int cols;
  T *linear;

 public:
  virtual int GetRows() = 0;

  virtual int GetColumns() = 0;

  virtual T GetElem(int i, int j) = 0;

  virtual void SetElem(int i, int j, T val) = 0;

  virtual void MatImport(T *arr) = 0;

  virtual ~Matrix() {
      delete[] (linear);
  }
};

template <typename T>
class RowMatrix : public Matrix<T> {
 public:
  RowMatrix(int r, int c) : Matrix<T>(r, c) {
      // the row order is the main order
      data_ = new T *[r];

      for (int i = 0; i < r; ++i) {
          data_[i] = &this->linear[i * c];
      }
  }

  // must use this->rows to return the base's member
  int GetRows() override { return this->rows; }

  int GetColumns() override { return this->cols; }

  T GetElem(int i, int j) override {
      if (i < 0 || i >= GetRows() || j < 0 || j >= GetColumns()) {
          // can not return nothing
          fprintf(stderr, "error: invalid index\n");
          exit(-1);
      }
      return data_[i][j];
  }

  void SetElem(int i, int j, T val) override {
      if (i < 0 || i >= GetRows() || j < 0 || j >= GetColumns()) {
          fprintf(stderr, "error: invalid index\n");
          return;
      }
      // assign the value
      data_[i][j] = val;
  }

  void MatImport(T *arr) override {
      for (int i = 0; i < GetRows(); ++i) {
          for (int j = 0; j < GetColumns(); ++j) {
              data_[i][j] = arr[GetColumns() * i + j];
          }
      }
  }
  ~RowMatrix() override {
      delete[] data_;
  }

 private:
  T **data_;
};

template <typename T>
class RowMatrixOperations {
 public:
  // Compute (mat1 + mat2) and return the result.
  static std::unique_ptr<RowMatrix<T>> AddMatrices(std::unique_ptr<RowMatrix<T>> mat1,
                                                   std::unique_ptr<RowMatrix<T>> mat2) {
      // Return nullptr if dimensions mismatch for input matrices.
      if (mat1->GetRows() == mat2->GetRows() && mat1->GetColumns() == mat2->GetColumns()) {
          std::unique_ptr<RowMatrix<T>> mat{new RowMatrix<T>(mat1->GetRows(), mat1->GetColumns())};
          for (int i = 0; i < mat1->GetRows(); ++i) {
              for (int j = 0; j < mat1->GetColumns(); ++j) {
                  mat->SetElem(i, j, mat1->GetElem(i, j) + mat2->GetElem(i, j));
              }
          }
          return mat;
      }
      fprintf(stderr, "error: The two matrices can not add\n");
      return std::unique_ptr<RowMatrix<T>>(nullptr);
  }

  // Compute matrix multiplication (mat1 * mat2) and return the result.
  static std::unique_ptr<RowMatrix<T>> MultiplyMatrices(std::unique_ptr<RowMatrix<T>> mat1,
                                                        std::unique_ptr<RowMatrix<T>> mat2) {
      // Return nullptr if dimensions mismatch for input matrices.
      if (mat1->GetColumns() != mat2->GetRows()) {
          fprintf(stderr, "error: The two matrices can not multiply\n");
          return std::unique_ptr<RowMatrix<T>>(nullptr);
      }
      int tmp_row = mat1->GetRows();
      int tmp_col = mat2->GetColumns();
      std::unique_ptr<RowMatrix<T>> mat{new RowMatrix<T>(tmp_row, tmp_col)};
      for (int i = 0; i < tmp_row; ++i) {
          for (int j = 0; j < tmp_col; ++j) {
              // initialize
              mat->SetElem(i, j, 0);
              for (int k = 0; k < mat1->GetColumns(); ++k) {
                  mat->SetElem(i, j, mat->GetElem(i, j) + mat1->GetElem(i, k) * mat2->GetElem(k, j));
              }
          }
      }
      return mat;
  }

  // Simplified GEMM (general matrix multiply) operation
  // Compute (matA * matB + matC).
  static std::unique_ptr<RowMatrix<T>> GemmMatrices(std::unique_ptr<RowMatrix<T>> matA,
                                                    std::unique_ptr<RowMatrix<T>> matB,
                                                    std::unique_ptr<RowMatrix<T>> matC) {
      // res1 = matA * matB
      std::unique_ptr<RowMatrix<T>> res1(MultiplyMatrices(std::move(matA), std::move(matB)));
      if (res1 == nullptr) {
          fprintf(stderr, "error: multiple result is null\n");
          return std::unique_ptr<RowMatrix<T>>(nullptr);
      }

      // res2 = res1 + matC
      std::unique_ptr<RowMatrix<T>> res2(AddMatrices(std::move(res1), std::move(matC)));
      if (res2 == nullptr) {
          fprintf(stderr, "error: add result is null\n");
          return std::unique_ptr<RowMatrix<T>>(nullptr);
      }
      return res2;
  }
};
}  // namespace bustub
