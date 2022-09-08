package com.di;

public class MallardDuck extends Duck {
	public MallardDuck() {}
	public MallardDuck(int leg, String name) {
		this.leg = leg;
		this.name = name;
	}
	@Override
	public void display() {
		System.out.println("나는 청둥오리 입니다.");
	}

}
