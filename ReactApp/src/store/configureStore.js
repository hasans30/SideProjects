import {createStore, applyMiddleware} from 'redux';
import rootReducer from '../reducers';
import thunk from 'redux-thunk';

export default function configureStore(initialState) {
   // console.log('calling configure store ###Hasan')
  return createStore(
    rootReducer,
    initialState,
    applyMiddleware(thunk)
  );
}
