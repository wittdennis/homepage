import type { Component } from 'solid-js';
import FontAwesomeIcon from '../atoms/FontAwesomeIcon';
import { css, cx } from '@emotion/css';

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
const FontAwesomeLink: Component<IFontAwesomeLinkProps> = (props: IFontAwesomeLinkProps) => (
    <div className={css`
            opacity: 0.5;
            &:hover {
                opacity: 1;
            }
        `}>
        <a className={css`
            color: black;
        `}
            target={props.openInNewTab ? '_blank' : ''} rel={props.openInNewTab ? 'noopener noreferrer' : ''} href={props.url}>
            <FontAwesomeIcon identifier={props.identifier} />
        </a>
    </div>
)

export default FontAwesomeLink;