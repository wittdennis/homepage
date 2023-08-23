import type { Component } from 'solid-js';
import { FontAwesomeIcon } from '../atoms/FontAwesomeIcon';
import { styled } from 'styled-components';

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
export const FontAwesomeLink: Component<IFontAwesomeLinkProps> = (
  props: IFontAwesomeLinkProps
) => (
  <Div>
    <A
      target={props.openInNewTab ? '_blank' : ''}
      rel={props.openInNewTab ? 'noopener noreferrer' : ''}
      href={props.url}
    >
      <FontAwesomeIcon identifier={props.identifier} />
    </A>
  </Div>
);

export default FontAwesomeLink;

const Div = styled.div`
  opacity: 0.5;

  &:hover {
    opacity: 1;
  }
`;

const A = styled.a`
  color: black;
`;
