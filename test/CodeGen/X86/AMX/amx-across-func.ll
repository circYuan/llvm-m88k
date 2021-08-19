; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+amx-int8 -mattr=+avx512f -verify-machineinstrs | FileCheck %s

%struct.__tile_str = type <{ i16, i16, [60 x i8], <256 x i32> }>

@buf = dso_local global [3072 x i8] zeroinitializer, align 64

define dso_local void @test_api(i16 signext %0, i16 signext %1) nounwind {
; CHECK-LABEL: test_api:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    subq $4056, %rsp # imm = 0xFD8
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    vpxord %zmm0, %zmm0, %zmm0
; CHECK-NEXT:    vmovdqu64 %zmm0, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb $1, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb %bpl, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw %bx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb %bpl, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw %bx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; CHECK-NEXT:    sttilecfg {{[-0-9]+}}(%r{{[sb]}}p) # 64-byte Folded Spill
; CHECK-NEXT:    movl $buf, %eax
; CHECK-NEXT:    movl $32, %r14d
; CHECK-NEXT:    movw $8, %r15w
; CHECK-NEXT:    tileloadd (%rax,%r14), %tmm1
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tilestored %tmm1, 2048(%rsp,%rax) # 1024-byte Folded Spill
; CHECK-NEXT:    movl $buf+1024, %eax
; CHECK-NEXT:    tileloadd (%rax,%r14), %tmm2
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tilestored %tmm2, 1024(%rsp,%rax) # 1024-byte Folded Spill
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    movl $buf+2048, %eax
; CHECK-NEXT:    ldtilecfg {{[-0-9]+}}(%r{{[sb]}}p) # 64-byte Folded Reload
; CHECK-NEXT:    tileloadd (%rax,%r14), %tmm0
; CHECK-NEXT:    movabsq $64, %rcx
; CHECK-NEXT:    tileloadd 2048(%rsp,%rcx), %tmm1 # 1024-byte Folded Reload
; CHECK-NEXT:    movabsq $64, %rcx
; CHECK-NEXT:    tileloadd 1024(%rsp,%rcx), %tmm2 # 1024-byte Folded Reload
; CHECK-NEXT:    tdpbssd %tmm2, %tmm1, %tmm0
; CHECK-NEXT:    tilestored %tmm0, (%rax,%r14)
; CHECK-NEXT:    addq $4056, %rsp # imm = 0xFD8
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    tilerelease
; CHECK-NEXT:    retq
  %3 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 %0, i16 8, i8* getelementptr inbounds ([3072 x i8], [3072 x i8]* @buf, i64 0, i64 0), i64 32)
  %4 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 %1, i8* getelementptr inbounds ([3072 x i8], [3072 x i8]* @buf, i64 0, i64 1024), i64 32)
  tail call void (...) @foo()
  %5 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 %0, i16 %1, i8* getelementptr inbounds ([3072 x i8], [3072 x i8]* @buf, i64 0, i64 2048), i64 32)
  %6 = tail call x86_amx @llvm.x86.tdpbssd.internal(i16 %0, i16 %1, i16 8, x86_amx %5, x86_amx %3, x86_amx %4)
  tail call void @llvm.x86.tilestored64.internal(i16 %0, i16 %1, i8* getelementptr inbounds ([3072 x i8], [3072 x i8]* @buf, i64 0, i64 2048), i64 32, x86_amx %6)
  ret void
}

declare dso_local void @foo(...)

declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, i8*, i64)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare void @llvm.x86.tilestored64.internal(i16, i16, i8*, i64, x86_amx)
