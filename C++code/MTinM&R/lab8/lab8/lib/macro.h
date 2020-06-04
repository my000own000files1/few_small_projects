#define BIT_IS_SET(Reg, b) ((Reg & _BV(b)) != 0)
#define BIT_IS_CLEAR(Reg, b) ((Reg & _BV(b)) == 0)
#define _BV(b) (1 << (b))
#define BitClr(var, bit) ((var) &= (~(1<<(bit))))
#define BitSet(var, bit) ((var) |= (1<<(bit)))


//3
#define MUX _BV(REFS0) //������ ������������  � ������������ ������� ���������� AVCC
#define high(var)  (var>>8)
#define low(var)    var
