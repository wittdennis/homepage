import type { Component } from 'solid-js';
import FontAwesomeIcon from '../atoms/FontAwesomeIcon';

/** Props for a FontAwesomeLink */
interface IFontAwesomeLinkProps {
    /** Font Awesome icon identifier */
    identifier: string;
    /** The url to link to */
    url: string;
    /** Whether or not to open the page in a new tab  */
    openInNewTab?: boolean;
}

/** Link as a font awesome icon */
const FontAwesomeLink: Component<IFontAwesomeLinkProps> = (props: IFontAwesomeLinkProps) => {
    return (        
        <a target={props.openInNewTab ? '_blank' : ''} rel={props.openInNewTab ? 'noopener noreferrer' : ''} href={props.url}>
            <FontAwesomeIcon identifier={props.identifier} />
        </a>                
    )
}

export default FontAwesomeLink;