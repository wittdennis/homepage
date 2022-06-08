import type { Component } from 'solid-js';
import '@fortawesome/fontawesome-free/css/all.min.css'

/** Props for a FontAwesomeIcon */
interface IFontAwesomeIconProps {
    /** Fontawesome icon identifier */
    identifier: string;
}

/** Renders a font awesome icon by its identifier */
const FontAwesomeIcon: Component<IFontAwesomeIconProps> = (props: IFontAwesomeIconProps) => {
    return (
        <i class={props.identifier} />
    )
}

export default FontAwesomeIcon;