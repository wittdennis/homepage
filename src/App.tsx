import type { Component } from 'solid-js';

import styles from './App.module.css';
import FontAwesomeLink from './molecules/FontAwesomeLink';

const App: Component = () => {
  return (
    <div class={styles.App}>
      <h1>Dennis Witt</h1>
      <h3>Developer</h3>
      <FontAwesomeLink identifier='fa-brands fa-github' url='https://github.com/wittdennis' openInNewTab={true} />
    </div>
  );
};

export default App;
