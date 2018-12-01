#include "stm32f10x.h"

int main(void)
{
	RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;

	GPIOC->CRH &= ~GPIO_CRH_CNF13;
	GPIOC->CRH |=  GPIO_CRH_MODE13_0;

	GPIOC->BSRR = GPIO_BSRR_BR13;

	while(1)
	{
		GPIOC->BSRR = GPIO_BSRR_BS13;
		for (uint16_t i = 0; i < 0xffff; i++);
		
		GPIOC->BSRR = GPIO_BSRR_BR13;
		for (uint16_t i = 0; i < 0xffff; i++);
	}

	return 0;
}
