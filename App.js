/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View,
    NativeEventEmitter,
    ActivityIndicator,
    NativeModules,
} from 'react-native';

const { CheckInvoice } = NativeModules;
const checkInvoiceEmitter = new NativeEventEmitter(CheckInvoice);


const instructions = Platform.select({
    ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
    android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {
    // 构造
      constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            info:''
        };
      }
    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>
                    Welcome to React Native!
                </Text>
                <Text style={styles.instructions}>
                    To get started, edit App.js
                </Text>
                <Text style={styles.instructions}>
                    UM push内容:{this.state.info}
                </Text>
            </View>
        );
    }

    componentDidMount() {
        //  监听iOS原生 UM push  监听外部通知
        checkInvoiceEmitter.addListener(
            'didReceiveNotification', (info) => {
                alert(info.aps.alert.body)
                this.setState({
                    info:info.aps.alert.body
                })
            }
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
});
