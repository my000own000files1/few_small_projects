/*
 * lab2.c
 *
 * Created: 11.09.2019 11:46:22
 * Author: Student   
 * 
 * Variant 8 
 * 8-ми разр. быстрая ШИМ 0x00FF
 */
#include <define.h>

interrupt [EXT_INT1] void int1Isr(void)
{
    // Если прерывание по фронту
    if(BIT_IS_SET(PIND, 1))
    {
        // Настраиваем прерывание на срез
        EICRA = _BV(ISC11);
        
        if(BIT_IS_CLEAR(PIND, 0))
        {
            angle+=1;
        }
        else    // Если на второй ножке высокий уровень
        {
            angle-=1;
        }
    }
    else
    {
        // Если прерывание по срезу
        // Настраиваем прерывание на фронт
        EICRA = _BV(ISC11) | _BV(ISC10);
        
        if(BIT_IS_CLEAR(PIND, 0))
        {
            angle-=1;
        }
        else        // Если на второй ножке высокий уровень
        {
            angle+=1;
        }
    }      
    if(angle>255)
    {
        angle=255;
    }           
     if(angle<0)
    {
        angle=0;
    } 
    
}

void main(void)
{   
    init_segments();
    
    #asm("sei");  //разрешение прерываний
    EICRA = _BV(ISC11) | _BV(ISC10) ;//на фронт
    EIMSK = _BV(INT1); 
    
    // Инициализация портов ввода/вывода
    DDRE = _BV(4) | _BV(5);
     
    // Инициализация таймера №3
    //  8-ми разр. быстрая ШИМ  , верхний предел — 0x00FF     
    // Сброс OC3B при совпадении TCNT3 с OCR3B (установка 0)   и установка OC3С при совпадении TCNT3 с OCR3C (установка 1)
    TCCR3A =  _BV(COM3B1) | _BV(COM3C1) | _BV(COM3C0) | _BV(WGM30);   
    TCCR3B = _BV(WGM32) | _BV(CS30);

while (1)
    {    
     indic_int(angle);
     OCR3CL = angle;
     OCR3BL = angle;
     delay_ms(20);
    }
}
