#include "p0_starter.h"
using namespace bustub;

int main() {
    std::unique_ptr<RowMatrix<int>> mat1_ptr{new RowMatrix<int>(2,3)};
    int arr1[9] = {1, 2, 3, 5, 0, -1};
    mat1_ptr->MatImport(&arr1[0]);

// 基本测试
    fprintf(stdout, "row=%d, col=%d\n", mat1_ptr->GetRows(), mat1_ptr->GetColumns());
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            fprintf(stdout, "%d, ", mat1_ptr->GetElem(i, j));
        }
    }

//// template test
//    std::unique_ptr<RowMatrix<float>> mat2_ptr{new RowMatrix<float>(3, 2)};
//    float arr2[6] = {2.5, 0.3, 0, 1.4, -1.5, 8};
//    mat2_ptr->MatImport(&arr2[0]);
//    fprintf(stdout, "\n\nrow=%d, col=%d\n", mat2_ptr->GetRows(), mat2_ptr->GetColumns());
//    for (int i = 0; i < 3; i++) {
//        for (int j = 0; j < 2; j++) {
//            fprintf(stdout, "%f, ", mat2_ptr->GetElem(i, j));
//        }
//    }
//
//
// AddMatrices test
    std::unique_ptr<RowMatrix<int>> mat3_ptr{new RowMatrix<int>(2,3)};
    int arr3[6] = {2, 2, 3, -5, 2, -4};
    mat3_ptr->MatImport(&arr3[0]);
    std::unique_ptr<RowMatrix<int>> mat_sum =
            RowMatrixOperations<int>::AddMatrices(std::move(mat1_ptr), std::move(mat3_ptr));
    fprintf(stdout, "\n");
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            fprintf(stdout, "%d, ", mat_sum->GetElem(i, j));
        }
    }




//    std::unique_ptr<RowMatrix<int>> mat4_ptr{new RowMatrix<int>(3,2)};
//    int arr4[9] = {1, 2, 3, 5, 0, -1};
//    mat4_ptr->MatImport(&arr4[0]);
//    std::unique_ptr<RowMatrix<int>> product_ptr =
//            RowMatrixOperations<int>::MultiplyMatrices(
//                    std::move(mat1_ptr), std::move(mat4_ptr)
//            );
//    fprintf(stdout, "\n");
//    for (int i = 0; i < 2; i++) {
//        for (int j = 0; j < 2; j++) {
//            fprintf(stdout, "%d, ", product_ptr->GetElem(i, j));
//        }
//    }
//
}
