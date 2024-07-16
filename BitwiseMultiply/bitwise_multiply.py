# 原理是，乘法本质就是b个a相加，
# 第一次迭代，当b的最低位为1时，就代表这个迭代是要加1个a，之后b右移一位，最低位维0，说明不需要加a
# 第二次迭代，当b的最低为为1时，代表这个迭代要加1<<1=2个a，之后b右移一位，最低位维0，说明不需要加a
# 第三次迭代，当b的最低为为1时，代表这个迭代要加1<<2=4个a，只有b右移一位，最低位维0，说明不需要加a
# 以此类推，直到b=0，说明结束了


def bitwise_multiply(a, b):
    result = 0
    shift = 0
    while b != 0:
        if b & 1: # b的最低位是1，代表b是奇数
            result += a << shift
        shift += 1
        b >>= 1 # b右移一位
    return result


def files_are_equal(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        for line1, line2 in zip(f1, f2):
            if line1 != line2:
                return False
    return True


result_file = 'result.txt'
result_bitwise_file = 'result_bitwise.txt'
flag = 0

with open(result_bitwise_file, 'a') as file_bitwise, open(result_file, 'a') as file:
    for a in range(10000): # 2^32 -1
        for b in range(10000):
            result = a * b
            result_bitwise = bitwise_multiply(a, b)
            file.write(str(result)+'\n')
            file_bitwise.write(str(result_bitwise)+'\n')
            flag += 1
            print(flag, result, result_bitwise)
                

file.close()
file_bitwise.close()

print('calculate done')

correct = files_are_equal(result_file, result_bitwise_file)

information = 'correct' if correct else 'fail'

print(f'algorithm {information}')