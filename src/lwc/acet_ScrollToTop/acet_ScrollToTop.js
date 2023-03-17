import { LightningElement } from 'lwc';

export default class Acet_ScrollToTop extends LightningElement {
    handleScroll(){
        window.scroll({
            top: 0, 
            left: 0, 
            behavior: 'smooth' 
        });
    }
}