/*
 * Created: 11.09.2019 11:46:22
 * Author: Student   
 * 
 * Variant 8 
 *  
 */
   
 
#include <define.h>
         
interrupt [EXT_INT7] void extIntIsr(void)
{
    // Если высокий уровень на ножке, то
    // это начало импульса
    if(BIT_IS_SET(PINE, 7))
    { 
        // Обнуляем счётный регистр таймера №3
        TCNT3H = 0;
        TCNT3L = 0;
    }
    else
    { 
        // Если низкий уровень на ножке, то
        // это конец импульса
        // Сохраняем текущее значение счётного регистра
        // таймера №3
        impulseWidth = TCNT3L;         //tick
        impulseWidth += (TCNT3H) << 8; //tick   
    }
}

void main(void)
{
    unsigned int length;    

    init_segments();
    DDRE = _BV(DDE6); // PORTE6 для подачи импульса на вход датчика  
          
    EICRB = _BV(ISC70) ; //настройка внешнего прервыания на любое изменение входного сигнала
    EIMSK = _BV(INT7);   //разрешение прерывания
    #asm("sei");  //разрешение прерываний        
    
    // Инициализация таймера №3
    TCCR3B =  _BV(CS31);    //freq=11.0529/8=1.382 MHz T=724 ns/tick            
    
    while(1)        
    {   
        length =impulseWidth*prop; //cm  преобразование значения таймера   
        BitSet(PORTE,DDE6);   
        delay_us(10); 
        BitClr(PORTE,DDE6);
        delay_ms(50);    //пауза для ожидания окончания измерения
        indic_uint(length);     //вывод значения на 
    }
}

